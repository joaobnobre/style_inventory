import Container from "./styled";
import { useSelector } from "react-redux";
import { useInventory } from "../../store/Inventory";
import { FC } from "react";
import MaskIcon from "../../assets/mascara.svg";
import { StyledItem } from '../Item/styled'

const Clothes = () => {
    const { clothes } = useSelector(useInventory);

    return (
        <Container>
            <div className="title collum">
                <span>ROUPAS</span>
                <span>DESEQUIPE SUAS ROUPAS COM FACILIDADE</span>
            </div>
            <div className="itens">
                <div className="itens-grid">
                    <ItemClotches data={{
                        ...clothes['cabeca'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['jaquetas'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['calca'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['sapatos'],
                        itemType: 'clothes',
                    }} />

                </div>
                <div className="itens-grid">
                    <ItemClotches data={{
                        ...clothes['mascara'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['oculos'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['mochila'],
                        itemType: 'clothes',
                    }} />
                    <ItemClotches data={{
                        ...clothes['colete'],
                        itemType: 'clothes',
                    }} />
                </div>
            </div>
        </Container>
    );
};

const ItemClotches: FC<{ data?: any; empty?: boolean }> = ({ data, empty }) => {
    return (
        <StyledItem
            className="center"
            style={{
                border:
                    data.itemType == "clothes" && data.item == -1
                        ? "1px dashed rgba(255, 255, 255, 0.1)"
                        : "none",
            }}
        >
            {data && data.item && data.item == -1 && (
                <img
                    src={MaskIcon}
                    alt=""
                    style={{
                        pointerEvents: "none",
                    }}
                />
            )}
        </StyledItem>
    );
};

export default Clothes;