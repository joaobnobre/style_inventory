import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

interface InitialState {
    asideType: string;
    infos: any;
    itens: any[];
    timeOpen: number;   
}

const INITIAL_STATE:InitialState = {
    asideType:'chest',
    infos: {
        current: 0,
        max: 0,
        name: 'Bau da polícia',
        text: undefined,
        type: 'chest',
    },
    itens: [],
    timeOpen: 0,
};

const AsideReducer = createSlice({
    name: "aside",
    initialState: INITIAL_STATE,
    reducers: {
        refreshAllAside: (state, action) => {
            const { infos, itens} = action.payload;
            state.infos = infos;
            state.itens = itens;
            state.timeOpen = Math.floor(new Date().getTime()/1000)
        },

        resetAside: (state) => {
            state = INITIAL_STATE;
        },

        setInfos: (state, action) => {
            const {max,current,name,type,text} = action.payload;
            state.infos = {
                max,
                current,
                name,
                type,
                text
            };
            
        },

        setItens: (state, action) => {
            const itens = action.payload
            state.itens = [];
            Object.values(itens).forEach((item: any) => {
                state.itens.push(item);  
            });
            state.timeOpen = Math.floor(new Date().getTime()/1000)
        },
    },
});

export default AsideReducer.reducer;

export const {
    setInfos,
    refreshAllAside,
    resetAside,
    setItens
} = AsideReducer.actions;

export const useAside = (state: any) => state.aside;
