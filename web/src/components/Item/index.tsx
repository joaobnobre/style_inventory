import { FC, useEffect } from "react";
import { Container,StyleDuration } from "./styled";
import { insertItem } from "../../store/Craft";
import { useDrag, useDrop } from "react-dnd";
import { toogleShow, setVisibility, useToolTip, setAmount } from "../ToolTip/ToolTip";
import { useDispatch, useSelector } from "react-redux";
import { Dutation, Usage } from './utils'

//onMaxUse

const Item: FC<{ data: any; empty?: boolean }> = ({ data, empty }) => {
    const dispatch = useDispatch();
    const { show, coordXY } = useSelector(useToolTip);

    if (empty) {
        return <Container />
    }

    const [dataDrag, drag] = useDrag({
        type: data.itemType,
        item: data,
        collect: (monitor: any) => ({
            isDragging: !!monitor.isDragging(),
        }),
    });

    useEffect(() => {
        if (dataDrag && dataDrag.isDragging && show) {
            dispatch(setVisibility({ show: false }));
        }
    }, [dataDrag]);

    const [, drop] = useDrop({
        accept: data.dropType,
        drop: (item: any) => {
            if (data.itemType == "craft") {
                if (item.key == data.item) {
                    dispatch(insertItem({ slot: data.slot }));
                }
            }
        },
    });

    const connectRef = (element: HTMLDivElement) => drag(drop(element));

    return (
        <Container
            ref={data.draggable ? connectRef : drop}
            style={{
                backgroundImage: `url(${import.meta.env.VITE_IP}/itens/${data.image}.png)`,
                justifyContent: data.itemType == "craft" ? "flex-end" : "space-between",
                backgroundPosition: data.itemType == "craft" ? "center top 30%" : "center",
                border: data.border ? data.border : "none",
                // filter: data.greyscale ? 'grayscale(' + data.greyscale + ')' : 'none',
                backgroundColor: data.color ? data.color : "rgba(255, 255, 255, 0.05)",
                boxShadow: data.color ? "inset 0px 0px 23.7253px rgba(57, 219, 69, 0.5)" : "none",
            }}
            onClick={() => data._CB && data._CB(data)}
            onContextMenu={(e: any) => {
                e.preventDefault();

                if (!data.key || data.store) return;
                if (
                    show &&
                    coordXY.x == e.target.offsetLeft - 47 &&
                    coordXY.y == e.target.offsetTop + 110
                ) {
                    dispatch(setVisibility({ show: false }));
                    return;
                }
                if (data.itemType == "inventory" || data.itemType == "aside") {
                    dispatch(
                        toogleShow({
                            show: true,
                            x: e.target.offsetLeft - 47,
                            y: e.target.offsetTop + 110,
                            data: data,
                            itemAmount:data.amount
                        })
                    );
                    dispatch(setAmount(data.amount))
                }
            }}
        >
            {data && data.itemType == "inventory" && (
                <div className="top center">
                    {data.amount}
                    <b>UND</b> | {(data.amount * data.weight).toFixed(2)} <b>KG</b>
                </div>
            )}

            {data && data.itemType == "aside" && !data.store && (
                <div className="top center">
                    {data.amount}
                    <b>UND</b> | {(data.amount * data.weight).toFixed(2)} <b>KG</b>
                </div>
            )}

            {data && data.itemType == "trade" && !data.store && (
                <div className="top center">
                    {data.amount}
                    <b>x</b>
                </div>
            )}

            {data && data.itemType == "aside" && data.store && (
                <div className="top center">
                    <b>$</b>
                    {(data.weight)} | {data.amount}
                    <b>x</b>
                </div>
            )}

            <div className="bottom collum">
                <ItemName name={data.name} />
                {data.duration && data.itemType != 'craft' && <Dutation item={data.key} value={data.duration} />}
                {data.itemType == 'craft' && data.fill && (
                    <StyleDuration style={{
                        display: data.fill > 0 ? 'flex' : 'none'
                    }}>
                        <div className="fill" style={{ width: data.fill + "%" }} />
                    </StyleDuration>
                )}
            </div>
            {data.usage && <Usage item={data.key} value={data.usage} amount={data.amount} />}
        </Container>
    );
};

const ItemName = ({ name }: any) => {
    return (
        <span
            style={{
                animation:
                    name.length > 15
                        ? "textAnimationTooltip 8s linear infinite"
                        : "",
            }}
        >
            {name}
        </span>
    );
};
export default Item;

