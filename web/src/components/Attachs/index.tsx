import { FC, useState } from "react";
import { useDrag, useDrop } from "react-dnd";
import { Container, Card, AttachCard } from "./styled";
import { useDispatch, useSelector } from "react-redux";
import { useAttachs, setWeapon, setAttachs, setSkins } from "./reducer";
import { fetchNui } from "../../utils/fetchNui";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const DropedAttach:FC<{item:any}> = ({item}) => {

    const [, drop] = useDrop({
        accept: ['inventory'],
        drop: (i: any) => {
            fetchNui('attachs:equipe', {drop:i, attach:item})
        },
    });

    return (
        <AttachCard
            mode={item.equiped ? 0 : 1}
            ref={drop}
            img={import.meta.env.VITE_IP + "/itens/" + item.image + ".png"}
            style={{
                filter: item.equiped ? 'grayscale(0)' : 'grayscale(1)'
            }}
        >
            <span style={{
                color: item.equiped ? 'rgba(255, 255, 255, 1)' : 'rgba(255, 255, 255, 0.5)'
            }}>{item.name}</span>
        </AttachCard>
    )
}

const Attachs = () => {
    const dispatch = useDispatch();
    const { weapon, attachs, skins } = useSelector(useAttachs);

    useNuiEvent('updateWeaponAttachs', (data: any) => dispatch(setAttachs(data)))

    useNuiEvent('updateWeaponSkins', (data: any) => dispatch(setSkins(data)))

    const [, drop] = useDrop({
        accept: ['weapon'],
        drop: (item: any) => {
            // console.log(JSON.stringify(item));

            dispatch(setWeapon(item));
            fetchNui('attachs:get', item)
        },
    });

    const handleSkin = (index: number) => {
        fetchNui('attachs:skin', {index: index, weapon: weapon.key})
    }

    return (
        <Container>
            <div className="title collum">
                <span>ATTACHS</span>
                <span>ARRASTE SUAS ARMAS NO SLOT, E ESCOLHA OS ATTACHS PERFEITOS!</span>
            </div>

            <Card img={import.meta.env.VITE_IP + "/itens/" + weapon.image + ".png"} ref={drop} onClick={() => {
                dispatch(setWeapon({}));
                dispatch(setAttachs([]));
                dispatch(setSkins({}))
            }}>
                <span>{weapon.name}</span>
                {weapon && weapon.image && <small>{weapon.ammo} /<b> {weapon.maxAmmo}</b></small>}
            </Card>

            <div className="attachs">
                {attachs.length > 0 && <div className="attachs-opt">
                    {attachs.map((item: any) => <DropedAttach item={item} />)}
                </div>}
                
                {skins.length > 0 &&
                    <div className="skins collum">
                        <span>PINTURA DA ARMA</span>
                        <div className="skins-grid">
                            {skins.map((item: any,index:number) => {
                                return (
                                    <div className="skins-card" onClick={() => handleSkin(index)}>
                                        <div className="skin" style={{ background: item }} />
                                    </div>
                                )
                            })}
                        </div>
                    </div>
                }
            </div>
        </Container>
    )
}

export default Attachs