import Container from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useInventory } from "../../store/Inventory";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const Infos = () => {
    const dispatch = useDispatch();
    const { infos } = useSelector(useInventory);



    return (
        <Container>
            <div className="title collum">
                <span>INFORMAÇÕES</span>
                <span>SOBRE SEU PERSONAGEM</span>
            </div>
            <div className="itens">
                <div className="item">
                    <span>seu id</span>
                    <small># {infos.id}</small>
                </div>
                <div className="item">
                    <span>telefone</span>
                    <small>{infos.phone}</small>
                </div>
                <div className="item">
                    <span>CARTEIRA</span>
                    <small>R$ {infos.bank}</small>
                </div>
                <div className="item">
                    <span>BANCO</span>
                    <small>R$ {infos.vip}</small>
                </div>

            </div>
        </Container>
    );
};

export default Infos; 