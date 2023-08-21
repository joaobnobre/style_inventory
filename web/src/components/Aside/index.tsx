import Item from "../Item";
import Container from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useAside, refreshAllAside, setItens, setInfos } from "./Aside";
import { useToolTip, setAmount,resetTool } from "../ToolTip/ToolTip";
import { useDrag, useDrop } from "react-dnd";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { debugData } from "../../utils/debugData";

debugData([
    {
        action: "updateAside",
        data: {
            itens: {
                ['joint']: { image: 'maconha', name: 'Baseado', key: 'joint', amount: '1', duration: '1677802682', weight: 1 },
            }
        }
    }
])


const Aside = () => {
    const { itens, infos } = useSelector(useAside);
    const { itemAmount } = useSelector(useToolTip);
    const dispatch = useDispatch();

    useNuiEvent('updateAside', (data: any) => {
        const { infos, itens } = data;
        dispatch(refreshAllAside(data));
        dispatch(setInfos(infos));
        dispatch(setItens(itens));
    })

    const [, drop] = useDrop({
        accept: ['inventory'],
        drop: (item: any) => {
            fetchNui('aside:store', { ...item, itemAmount: itemAmount || item.amount })
            dispatch(resetTool())
        },
    });

    return (
        <Container ref={drop}>
            <div className="title collum">
                <span>{infos.name}</span>
                <span>{infos.text ? infos.text : 'secundário'}</span>
                <div className="infos">
                    {infos.type && infos.type != 'store' && <div className="infos-value">
                        <span>peso</span>
                        <span>{(infos.current).toFixed(2)}/<b>{(infos.max).toFixed(2)}kg</b></span>
                    </div>}
                    {infos.type && infos.type != 'store' && <div className="infos-bar">
                        <div className="fill" style={{ width: (infos.current / infos.max) * 100 + "%" }}></div>
                    </div>}
                </div>
            </div>
            <div className="itens">
                {itens.map((item: any, index: number) => {

                    return (
                        <Item
                            empty={false}
                            key={index}
                            data={{
                                ...item,
                                dropType: ['inventory'],
                                itemType: 'aside',
                                draggable: true,
                                store: infos.type == 'store',
                            }}
                        />
                    );
                })}
                {itens.length < 24 && Array.from({ length: 24 - itens.length }).map((_, index) => (<Item empty={true} key={index} data={{}} />))}
            </div>
        </Container>
    );
};

export default Aside;