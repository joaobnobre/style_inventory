import { createSlice } from "@reduxjs/toolkit";

interface InitialState {
    show: boolean;
    data: any;
    coordXY: { x: number, y: number };
    itemAmount: number;
}

const INITIAL_STATE: InitialState = {
    show: false,
    data: {},
    coordXY: { x: 1500, y: 900 },
    itemAmount: 0,
};

const ToolTipReducer = createSlice({
    name: "tooltip",
    initialState: INITIAL_STATE,
    reducers: {
        toogleShow(state, action) {
            const { data, x, y, show,itemAmount } = action.payload;
            state.data = data;
            state.show = show;
            state.coordXY = { x: x, y: y }
            if(itemAmount) state.itemAmount = itemAmount
            // return { 
            //     ...state, 
            //     show: show,
            //     data: data,
            //     coordXY: { x: x, y: y},
            // };
        },

        setVisibility(state, action) {
            const { show } = action.payload;
            return {
                ...state,
                show: show,
            };
        },

        setAmount(state, action) {
            return {
                ...state,
                itemAmount: action.payload,
            }
        },

        resetTool(state) {
            return INITIAL_STATE
        }
    },
});

export default ToolTipReducer.reducer;
export const { toogleShow, resetTool, setVisibility, setAmount } = ToolTipReducer.actions;
export const useToolTip = (state: any) => state.tooltip;
