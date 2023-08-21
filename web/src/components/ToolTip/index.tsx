import { MouseEventHandler, useEffect, useState } from "react";
import Container from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { setVisibility, useToolTip, setAmount, resetTool } from "./ToolTip";
import { fetchNui } from "../../utils/fetchNui";
import { useGlobal } from "../../store/Global";


const ToolTip = () => {
    const [hover, setHover] = useState("");
    const { data, show, coordXY, itemAmount } = useSelector(useToolTip);
    const { frontType } = useSelector(useGlobal);
    const [strDate, setstrDate] = useState('');
    const dispatch = useDispatch();

    useEffect(() => {
        setHover(data.name);
        if (data.duration) {
            const time = new Date(data.duration * 1000);
            const hours = time.getHours();
            const minutes = time.getMinutes();
            const seconds = time.getSeconds();
            const duration = `${hours}h${minutes}m${seconds}s`;
            setstrDate(duration)
        }
    }, [data]);

    const useItem = () => {
        fetchNui("useItem", data);
        dispatch(setVisibility({ show: false }));
    };

    const removeItem = () => {
        fetchNui("removeItem", { ...data, amount: itemAmount || data.amount });
        dispatch(setVisibility({ show: false }));
    };

    const tradeAdd = () => {
        fetchNui("trade:addItem", { ...data, itemAmount: itemAmount });
        //dispatch(insertItem(data));
        dispatch(setVisibility({ show: false }));
    };

    // const ShowDuration = (value: number) => {
    //     if (!value) {
    //         setHover(data.name);
    //     } else {
    //         const time = new Date(value * 1000);
    //         const hours = time.getHours();
    //         const minutes = time.getMinutes();
    //         const seconds = time.getSeconds();
    //         const duration = `${hours}h${minutes}m${seconds}s`;
    //         setHover(duration);
    //     }
    // };

    return (
        <Container
            // onClick={(event) => )}
            style={{
                display: show ? "flex" : "none",
                visibility: show ? "visible" : "hidden",
                left: coordXY.x,
                top: coordXY.y,
            }}
        >
            <div className="top">
                <div
                    className="top-img"
                    style={{
                        backgroundImage: `url(${import.meta.env.VITE_IP}/itens/` + data.image + ".png)",
                    }}
                />
                <div className="top-infos">
                    <span
                        inputMode="text"
                        onMouseEnter={() => {
                            if (data.duration) setHover(strDate);

                        }}
                        style={{
                            animation: data && data.name && data.name.length > 15 ?
                                "textAnimationTooltip 8s linear infinite"
                                : "",
                        }}
                        // onMouseEnter={() => ShowDuration(data.duration)}
                        onMouseLeave={() => setHover(data.name)}
                    >
                        {hover}
                    </span>
                    <input
                        type="text"
                        placeholder={`x${data.amount}`}
                        value={itemAmount > 0 ? `x${itemAmount}` : `x${data.amount}`}
                        onChange={(e) => {
                          const newValue = parseInt(e.target.value.replace('x', ''));
                          dispatch(setAmount(newValue));
                        }}
                    />
                </div>
            </div>
            {data.itemType && data.itemType !== 'aside' && <div className="bottom">
                {frontType !== 'trade' && <button onClick={useItem} style={{width:'50%'}}>Usar</button>}
                {frontType !== 'trade' && <button onClick={removeItem} style={{width:'50%'}}>{DropReducer(data.duration || null)}</button>}
                {frontType == 'trade' && <button onClick={tradeAdd} style={{width:'100%'}}>trocar</button>}
            </div>}
        </Container>
    );
};

function DropReducer(value: number | null) {
    if (!value) return 'Soltar'
    const timeOpen = Number(localStorage.getItem('ostime'))
    if (timeOpen >= value) return 'Remover'
    if (timeOpen < value) return "Soltar"
}

export default ToolTip;
