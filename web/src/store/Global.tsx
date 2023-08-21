import { createSlice } from "@reduxjs/toolkit";
import { useNuiEvent } from "../hooks/useNuiEvent";

const INITIAL_STATE = {
    frontType: "aside",
    frontMode: "aside",
    ostime: Math.floor(new Date().getTime() / 1000)
};

const GlobalReducer = createSlice({
    name: "global",
    initialState: INITIAL_STATE,
    reducers: {
        setFrontType: (state, action) => {
            state.frontType = action.payload;
        },

        setFrontMode: (state, action) => {
            state.frontMode = action.payload;
        },
    },
});

export default GlobalReducer.reducer;

export const {
    setFrontType,
    setFrontMode,
} = GlobalReducer.actions;

export const useGlobal = (state: any) => state.global;
