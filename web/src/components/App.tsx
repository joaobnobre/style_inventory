import { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import Container from "./styled";
import { Trade,Header, Weapons, Inventory, HotBar, Clothes, Infos, Attachs, Aside, ToolTip, DragPreview, } from "./";
import { Craft, SelectCraft } from "./Craft";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { setFrontType, useGlobal, setFrontMode } from "../store/Global";
import { resetCraft } from "../store/Craft";
import { resetTool } from "./ToolTip/ToolTip";
import { resetAttachs } from "./Attachs/reducer";
import { resetTrade } from "./Trade/reducer";
import { isEnvBrowser } from "../utils/misc";

const App = () => {
    const dispatch = useDispatch();
    const [visible, setVisible] = useState(isEnvBrowser() ? true : false);
    const { frontType } = useSelector(useGlobal);

    useNuiEvent("setVisible", (data) => {
        setVisible(data);
        if (!data) {
            dispatch(resetCraft())
            dispatch(resetTool())
            dispatch(resetAttachs())
            dispatch(resetTrade())
        }
    });

    useNuiEvent('ostime',(data) => {
        localStorage.setItem('ostime',data.toString())
    })

    useNuiEvent('frontType', (data) => {
        dispatch(setFrontType(data));
    })

    useNuiEvent('frontMode', (data) => {
        dispatch(setFrontMode(data));
    })

    useEffect(() => {
        if (!visible) return;
        const keyHandler = (e: KeyboardEvent) => {
            if (["Escape"].includes(e.code)) {
                fetchNui("hideFrame")

                // setVisible(!visible)
            }
        }

        window.addEventListener("keydown", keyHandler)

        return () => window.removeEventListener("keydown", keyHandler)
    }, [visible])

    return (
        <Container style={{
            display: visible ? "flex" : "none"
        }}>
            <div className="screen">
                <DragPreview />
                <ToolTip />
                <Header />
                <div className="main">
                    <Weapons />
                    <div className="main-inventory">
                        <Inventory />
                        <HotBar />
                    </div>
                    <div className="main-aside">
                        {/* {frontType && frontType == 'inventory' && <Clothes />} */}
                        {frontType && frontType == 'inventory' && <Infos />}

                        {frontType && frontType == 'craft' && <Craft />}
                        {frontType && frontType == 'craft' && <SelectCraft />}

                        {frontType && frontType == 'aside' && <Aside />}
                        {frontType && frontType == 'trade' && <Trade />}
                        {frontType && frontType == 'attachs' && <Attachs />}
                    </div>
                </div>
            </div>
        </Container>
    );
};

export default App;