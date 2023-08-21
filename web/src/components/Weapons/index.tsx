import { Container, Card } from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useDrag, useDrop } from "react-dnd";
import { FC,useState } from "react";
import { fetchNui } from "../../utils/fetchNui";
import { useToolTip, resetTool } from "../ToolTip/ToolTip";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { useGlobal } from "../../store/Global";

const Item: FC<{ props: any }> = ({ props }) => {
    const { itemAmount } = useSelector(useToolTip);
    const { frontType } = useSelector(useGlobal);
    const dispatch = useDispatch()

    const [, drag] = useDrag({
        type: 'weapon',
        item: props,
    });

    const [, drop] = useDrop({
        accept: ['inventory'],
        drop: (item: any) => {
            if(frontType !== 'inventory') return
            fetchNui('inventory:equipweapon', { ...item, amount: itemAmount > 0 && itemAmount != item.amount ? itemAmount : item.amount })
            dispatch(resetTool())
        },
    });

    const connectRef = (element: HTMLDivElement) => drag(drop(element));

    return <Card img={import.meta.env.VITE_IP + "/itens/" + props.image + ".png"} ref={connectRef}>
        <span>{props.name}</span>
        {props && props.image && <small>{props.ammo} /<b> {props.maxAmmo}</b></small>}
    </Card>
}

const Weapons = () => {
    const [weapons, setWeapons] = useState<any[]>([]);

    useNuiEvent('updateWeapon', (data: any) => {
        setWeapons(data);
    })

    return (
        <Container>
            <div className="title collum">
                <span>ARMAS</span>
                <span>EQUIPADAS</span>
            </div>
            <div className="content">
                {weapons.map((weapon: any, index: number) => <Item props={{ ...weapon, itemType: 'weapon', }} key={index} />)}
                {weapons.length < 6 && Array.from({ length: 6 - weapons.length }).map((_, index) => <Item props={{

                }} key={index} />)}
            </div>
        </Container>
    );
};

export default Weapons;