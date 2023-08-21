import Item from "../Item";
import Container from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useInventory, setItens, setInfos } from "../../store/Inventory";
import { useDrop } from "react-dnd";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { debugData } from "../../utils/debugData";
import { useToolTip, setVisibility, resetTool } from "../ToolTip/ToolTip";
import { useGlobal } from "../../store/Global";


debugData([
    {
        action: "updateInventory",
        data: {
            ['compostoadrenalina2']: { image: 'compostoadrenalina2', name: 'Composto de Adrenalina II', key: 'joint', amount: '1', duration: false, weight: 1 },
        }
    }
])

const Inventory = () => {
    const dispatch = useDispatch();
    const { itens, infos } = useSelector(useInventory);
    const { itemAmount } = useSelector(useToolTip);
    const { frontType } = useSelector(useGlobal);

    useNuiEvent('updateInventory', (data: any) => {
        dispatch(setItens(data));
    })

    useNuiEvent('updatePlayerInfos', (data: any) => {
        dispatch(setInfos(data))
    })

    const [, drop] = useDrop({
        accept: ['aside', 'weapon'],
        drop: (item: any) => {
            const { itemType } = item;
            if (itemType === 'weapon' && frontType == 'inventory') {
                fetchNui('inventory:gweapon', item)
            } else if (itemType == 'aside') {
                fetchNui('aside:take', { ...item, itemAmount: itemAmount || item.amount })
                dispatch(setVisibility({ show: false }));
                dispatch(resetTool());

            }
        },
    });

    return (
        <Container ref={drop}>
            <div className="title collum">
                <span>INVENTÁRIO</span>
                <span>PRINCIPAL</span>
                <div className="infos">
                    <div className="infos-value">
                        <span>peso</span>
                        <span>{(infos.current).toFixed(2)}/<b>{(infos.max).toFixed(2)}kg</b></span>
                    </div>
                    <div className="infos-bar">
                        <div className="fill" style={{ width: (infos.current / infos.max) * 100 + "%" }}></div>
                    </div>
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
                                dropType: ['aside'],
                                itemType: 'inventory',
                                draggable: true,
                            }}
                        />
                    );
                })}
                {itens.length < 20 && Array.from({ length: 20 - itens.length }).map((_, index) => (<Item empty={true} key={index} data={{}} />))}
            </div>
        </Container>
    );
};

export default Inventory;