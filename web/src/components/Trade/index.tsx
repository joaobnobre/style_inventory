import { useDispatch, useSelector } from "react-redux";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import Item from "../Item";
import {setTradeState, setOwner,useTrade, setPrimaryItens,setSecondaryItens,setPlayerName,removeItem} from "./reducer";
import Container from "./styled";


const Trade = () => {
    const dispatch = useDispatch();
    const { osTime, owner, primaryItens,secondaryItens,playerName,tradeState } = useSelector(useTrade);

    useNuiEvent('setOwner', (data: any) => {
        dispatch(setOwner(data))
    })

    useNuiEvent('setItensPrimary',(data:any) => dispatch(setPrimaryItens(data)))

    useNuiEvent('setItensSecondary',(data:any) => dispatch(setSecondaryItens(data)))

    useNuiEvent('setPlayerName',(name:string) => dispatch(setPlayerName(name)))

    useNuiEvent('setTradeState',(data:any) => dispatch(setTradeState(data)))

    const handleAcept = () => {
        if(owner && tradeState[0] == 1 && tradeState[1] == 1) return
        if(!owner && tradeState[0] == 1 && tradeState[1] == 1){
            fetchNui('trade:finish')
        } else {
            fetchNui('trade:send',tradeState[0])
        }
    }

    const _CB = (data: any) => {
        data._CB = null
        fetchNui('trade:removeItem',{key:data.key,duration:data.duration})
        // dispatch(removeItem(data))
    }

    return (
        <Container>
            <div className="title collum">
                <span>ITENS PARA TROCA</span>
                <span>TROCA COM {playerName}</span>
            </div>
            <div className="trade">
                <div className="trade-top">
                    <div className="trade-circle" />
                    <div className="trade-info">
                        <span>você</span>
                        <span style={{
                            color: tradeState[0] === 1 ? 'rgba(57, 219, 69, 1)' : 'rgba(219, 57, 96, 1)'
                        }}>{tradeState[0] === 0 ? 'NÃO CONFIRMADO' : 'CONFIRMADO'}</span>
                    </div>
                    <div
                        className="trade-acept center"
                        style={{
                            backgroundColor: tradeState[0] == 0 ||  (owner && tradeState[0] == 1 && tradeState[1] == 1)? 'rgba(57, 219, 69, 0.2)' : 'rgba(219, 57, 96, 0.2)'
                        }} 
                        // className={(tradeState[0] === 0 && tradeState[1] == 0) ? "trade-acept center state-0" : "trade-acept center state-1"}
                        onClick={handleAcept}
                    >
                        {tradeState[0] == 0 && 'Enviar proposta'}
                        {tradeState[0] == 1 && tradeState[1] == 0 && 'Cancelar'}
                        {!owner && tradeState[0] == 1 && tradeState[1] == 1 && 'Aceitar trade'}
                        {owner && tradeState[0] == 1 && tradeState[1] == 1 && 'Aguarde a confirmação'}
                    </div>
                </div>
                <div className="trade-itens">
                    {Object.values(primaryItens).map((item: any, index: number) => {
                        const duration = ((item.duration - osTime) / item.maxDurability) * 100
                        return (<Item
                            empty={false}
                            key={index}
                            data={{
                                ...item,
                                dropType: ['inventory'],
                                itemType: 'trade',
                                draggable: false,
                                fill: duration > 0 ? duration : false,
                                color: tradeState[0] === 1 ? 'rgba(57, 219, 69, 0.2)' : null,
                                _CB: _CB
                            }}/>)
                    })}
                    {Object.values(primaryItens).length < 8 && Array.from({ length: 8 - Object.values(primaryItens).length }).map((_, index) => (<Item empty={true} key={index} data={{}} />))}
                </div>
            </div>
            
            <div className="trade">
            <div className="trade-top">
                    <div className="trade-circle" />
                    <div className="trade-info">
                        <span>{playerName}</span>
                        <span style={{
                            color: tradeState[1] === 1 ? 'rgba(57, 219, 69, 1)' : 'rgba(219, 57, 96, 1)'
                        }}>{tradeState[1] === 0 ? 'NÃO CONFIRMADO' : 'CONFIRMADO'}</span>
                    </div>
                </div>
                <div className="trade-itens">
                    {Object.values(secondaryItens).map((item: any, index: number) => {
                        const duration = ((item.duration - osTime) / item.maxDurability) * 100
                        return (<Item
                            empty={false}
                            key={index}
                            data={{
                                ...item,
                                dropType: ['inventory'],
                                itemType: 'trade',
                                draggable: false,
                                fill: duration > 0 ? duration : false,
                                color: tradeState[1] === 1 ? 'rgba(57, 219, 69, 0.2)' : null,
                            }}/>)
                    })}
                    {Object.values(secondaryItens).length < 8 && Array.from({ length: 8 - Object.values(secondaryItens).length }).map((_, index) => (<Item empty={true} key={index} data={{}} />))}
                </div>
            </div>
        </Container>
    )
}

export default Trade;