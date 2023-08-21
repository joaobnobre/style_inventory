import { Container, StyleItem } from "./styled";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { useDrop } from "react-dnd";
import { HotbarType } from "../../types/hotbar.type"
import { useState } from "react";

const ItemHotbar: React.FC<HotbarType> = ({ data, bind }) => {
    const [, drop] = useDrop({
        accept: ['inventory'],
        drop: (item: any) => {
            fetchNui("addHotbar", {
                item: item,
                slot: data.slot,
            });
        },
    });

    return (
        <StyleItem
            ref={drop}
            style={{
                backgroundImage: `url(${import.meta.env.VITE_IP}/itens/${data.image}.png)`,
            }}
            onContextMenu={(e: any) => {
                e.preventDefault();
                fetchNui("removeHotbar", data.slot);
            }}
        >
            <span className="center">{bind}</span>
            <small
                style={{
                    animation: data.name.length > 15 ?
                        "textAnimation 8s linear infinite"
                        : "",
                }}
            >
                {data.name}
            </small>
        </StyleItem>
    );
}

const HotBar = () => {
    const [hotbar, setHotbar] = useState<any[]>([
        { key: '', image: '', name: '', slot: 1, amount: 0 },
        { key: '', image: '', name: '', slot: 2, amount: 0 },
        { key: '', image: '', name: '', slot: 3, amount: 0 },
        { key: '', image: '', name: '', slot: 4, amount: 0 },
        { key: '', image: '', name: '', slot: 5, amount: 0 },
    ]);

    useNuiEvent('updateHotBar', (data: any) => {
        setHotbar(data);
    })

    return (
        <Container>
            <div className="title collum">
                <span>HOTBAR</span>
                <span>UTILIZE OS ATALHOS PARA FACILITAR SEU ROLEPLAY</span>
            </div>
            <div className="itens">
                <ItemHotbar
                    data={hotbar[0]}
                    bind={1}
                />
                <ItemHotbar
                    data={hotbar[1]}
                    bind={2}

                />
                <ItemHotbar
                    data={hotbar[2]}
                    bind={3}

                />
                <ItemHotbar
                    data={hotbar[3]}
                    bind={4}
                />
                <ItemHotbar
                    data={hotbar[4]}
                    bind={5}
                />
            </div>
        </Container>
    );
};

export default HotBar; 