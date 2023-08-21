import Item from "../Item";
import Container, { ContainerSelected } from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useCraft, setSelecionada, setReceitas, resetCraft, craftItem } from "../../store/Craft";
import ArrowIcon from "../../assets/Arrow.svg";
import { Swiper, SwiperSlide } from 'swiper/react';
import 'swiper/css';
import { useEffect, useRef, useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";

const Craft = () => {
    const { selecionada, blocked } = useSelector(useCraft);
    const dispatch = useDispatch();
    const [timer, setTimer] = useState(0);
    let timerId: undefined | any;

    const _CB = (e: any) => {
        if (selecionada.item.avaliable && !blocked) {
            fetchNui('craft:createItem', selecionada.item)
                .then(data => {
                    if (!data) {
                        dispatch(resetCraft());
                        setTimer(0)
                    } else {
                        dispatch(craftItem());
                        setTimer(selecionada.time)
                    }
                })
        }
    }


    useEffect(() => {
        if (blocked) {
            timerId = !timerId && setInterval(() => {
                setTimer(prev => prev - 1)
            }, 1000);

            if (timer <= 0) {
                dispatch(resetCraft());
                fetchNui('craft:update')
                clearInterval(timerId)
            }
        }
        return () => clearInterval(timerId)
    }, [timer]);

    return (
        <Container>
            <div className="title collum">
                <span>CRAFTING</span>
                <span>SELECIONE A RECEITA, PARA INICIAR O CRAFT</span>
            </div>
            <div className="content">
                <div className="itens">
                    {selecionada.receita.map((item: any, index: number) => {
                        return (
                            <div key={index}>
                                
                                <Item
                                    empty={false}
                                    data={{
                                        ...item,
                                        border: selecionada.receita[index].dropped ? 'none' : '1px dashed rgba(255, 255, 255, 0.3)',
                                        greyscale: item.dropped ? '0' : '1',
                                        itemType: 'craft',
                                        dropType: ['inventory'],
                                    }}
                                />
                            </div>
                        );
                        
                    })}
                </div>
                <img src={ArrowIcon} alt="" />
                <div className="create">
                    <Item
                        empty={false}
                        data={{
                            ...selecionada.item,
                            border: selecionada.item.avaliable ? 'none' : '1px dashed rgba(255, 255, 255, 0.3)',
                            greyscale: selecionada.item.avaliable ? '0' : '1',
                            itemType: 'craft',
                            dropType: ['block'],
                            _CB: _CB,
                            //duration: selecionada.time > 0 ? selecionada.time : false,
                            // current: timer,
                            fill: timer > 0 ? (timer / selecionada.time) * 100 : false,
                        }}
                    />
                </div>
            </div>
        </Container>
    );
};

const SelectCraft = () => {
    const sliderRef = useRef(null);
    const { receitas, blocked } = useSelector(useCraft);
    const dispatch = useDispatch();

    useNuiEvent('setReceitas', (data: any) => {
        dispatch(setReceitas(data));
    })

    const _CB = (e: any) => {
        if (blocked) return;
        dispatch(resetCraft());
        fetchNui('GetItemCraft', e).then((data: any) => {
            if (data) {
                dispatch(setSelecionada(data));
            }
        })
    }


    return (
        <ContainerSelected style={{
            visibility: blocked ? 'hidden' : 'visible'
        }}>
            <div className="title collum">
                <span>CRAFTINGS DISPONÍVEIS</span>
                <span>ITENS DISPONÍVEIS PARA CRAFT, SELECIONE E VEJA A RECEITA</span>
            </div>
            <div className="itens">
                <Swiper
                    spaceBetween={10}
                    style={{ width: '100%', height: '100%' }}
                    slidesPerView={5}
                    observeParents={true}
                    navigation
                    // @ts-ignore
                    ref={sliderRef}
                >
                    {receitas.map((item: any, index: number) => {
                        return (
                            <SwiperSlide key={index} style={{position:'relative'}}>
                                <Item empty={false} data={{
                                    ...item,
                                    itemType: 'craft',
                                    _CB: _CB,
                                    dropType: ['block'],
                                    border: !blocked ? 'none' : '1px dashed rgba(255, 255, 255, 0.3)',
                                    greyscale: !blocked ? '0' : '1',
                                }} />
                            </SwiperSlide>
                        )
                    })}
                    {receitas.length < 4 && Array.from({ length: 24 - receitas.length }).map((_, index) => (<Item empty={true} key={index} data={{}} />))}

                </Swiper>
            </div>
        </ContainerSelected>
    );
}

export {
    Craft,
    SelectCraft
};