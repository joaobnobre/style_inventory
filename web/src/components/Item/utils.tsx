import { FC } from "react";
import { StyleDuration, StyleUsage } from "./styled";
import Load from '../../utils/itens.json'
const Itens = Load as any

type utils = {
    item: string,
    value: number,
    amount?:number
}

const Dutation: FC<utils> = ({ item, value }) => {
    const maxDurability = Itens.durability[item]
    if (!maxDurability) return <StyleDuration style={{ display: 'none' }} />
    const timeOpen = Number(localStorage.getItem('ostime'))
    const fill = ((value - timeOpen) / maxDurability) * 100
    return (
        <StyleDuration style={{
            display: fill > 0 ? 'flex' : 'none'
        }}>
            <div className="fill" style={{ width: fill + "%" }} />
        </StyleDuration>
    )
}

const Usage: FC<utils> = ({ item, value,amount }) => {
    
    const max = Itens.usage[item]
    if (!max || !amount) return <StyleUsage style={{ display: 'none' }} />
    const fill = (value / (amount * max)) * 100
    console.log(value,max,fill);
    return (
        <StyleUsage style={{
            display: fill > 0 ? 'flex' : 'none'
        }}>
            <div className="fill" style={{ height: fill + "%" }} />
        </StyleUsage>
    )
}

export {
    Dutation,
    Usage
}