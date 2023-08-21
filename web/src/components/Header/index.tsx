import Container from "./styled";
import { useSelector, useDispatch } from "react-redux";
import { useGlobal, setFrontType } from "../../store/Global";
import { resetCraft } from "../../store/Craft";
import { fetchNui } from "../../utils/fetchNui";
import { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const Header = () => {
    const { frontType, frontMode } = useSelector(useGlobal);
    const [showAttachs,setShowAttachs] = useState(false)
    const [showInventory,setShowInventory] = useState(true)
    const [showHeader,setShowHeader] = useState(true)
    const dispatch = useDispatch();

    useNuiEvent<boolean>('showAttachs',setShowAttachs)
    useNuiEvent<boolean>('showInventoryHeader',setShowInventory)
    useNuiEvent<boolean>('showHeader',setShowHeader)

    const handleFrontType = (type: string) => {

        if (frontType == "attachs" && type == "inventory") {
            dispatch(setFrontType(type));
            return;
        }
        if(frontMode == "inventory" && type == "attachs"){
            dispatch(setFrontType(type));
            return;
        }

        if (frontMode == "inventory" || frontMode == "aside") return;

        dispatch(setFrontType(type));
        dispatch(resetCraft());
        
        if (type == "attachs") {
            dispatch(setFrontType(type));
            return;
        }
        if (type == "craft") {
            fetchNui("craft:update");
        }
    };

    const attachsFix = () => {
        return (
            frontType == "attachs" ? (
                <span className="center">
                    ATTACHS 
                    <div className="fx"/>
                </span>
            ) : (
                <span
                    className="center"
                    onClick={() => handleFrontType("attachs")}
                    style={{
                        color:
                            frontMode == "aside"
                                ? "rgba(255, 255, 255, 0.05)"
                                : "#fff",
                    }}
                >
                    ATTACHS
                </span>
            )
        )
    }

    const inventoryFix = () => {
        return (
            frontType == "inventory" || frontType == "aside" ? (
                <span className="center">
                    INVENTARIO <div className="fx"></div>
                </span>
            ) : (
                <span
                    className="center"
                    onClick={() => handleFrontType("inventory")}
                >
                    INVENTARIO
                </span>
            )
        )
    }

    return (
        <Container style={{
            display: showHeader ? 'flex' : 'none'
        }}>
            <div className="header">
                {showInventory && inventoryFix()}

                {frontType == "craft" ? (
                    <span className="center">
                        CRAFT <div className="fx"></div>
                    </span>
                ) : (
                    <span
                        className="center"
                        onClick={() => handleFrontType("craft")}
                        style={{
                            color:
                                frontMode == "inventory" || frontMode == "aside"
                                    ? "rgba(255, 255, 255, 0.05)"
                                    : "#fff",
                                    display:'none'
                        }}
                    >
                        CRAFT
                    </span>
                )}
                {showAttachs && attachsFix()}
            </div>
        </Container>
    );
};

export default Header;
