import { createSlice } from "@reduxjs/toolkit";

interface InitialState {
    infos: {
        current: number;
        max: number;
        vip: string;
        bank: number;
        phone: string;
        id: number;
    };
    itens: any[];
    clothes: any;
    timeOpen: number;

}

const INITIAL_STATE: InitialState = {
    timeOpen: 0,
    infos: {
        current: 0,
        max: 0,
        vip: 'none',
        bank: 0,
        phone: '',
        id: 0,
    },
    itens: [],
    clothes: {
        'cabeca': { item: -1 },
        'jaquetas': { item: -1 },
        'calca': { item: -1 },
        'sapatos': { item: -1 },

        'mascara': { item: -1 },
        'oculos': { item: -1 },
        'mochila': { item: -1 },
        'colete': { item: 1 },
    }
};

const InventoryReducer = createSlice({
    name: "inventory",
    initialState: INITIAL_STATE,
    reducers: {
        refreshAllInventory: (state, action) => {
            const { infos, itens, clothes } = action.payload;
            state.infos = infos;
            state.itens = itens;
            state.clothes = clothes;
        },

        resetInventory: (state) => {
            return  INITIAL_STATE;
        },

        setInfos: (state, action) => {

            state.infos = action.payload;
        },

        setItens: (state, action) => {
            state.timeOpen = Math.floor(new Date().getTime() / 1000)
            const itens = action.payload
            state.itens = [];
            Object.values(itens).forEach((item: any) => {
                if (item.duration && item.duration <= state.timeOpen) {
                    item.name = 'vencido'
                }
                state.itens.push(item);
            });
        },

        setClothes: (state, action) => {
            state.clothes = action.payload;
        }
    },
});

export default InventoryReducer.reducer;

export const {
    setInfos,
    refreshAllInventory,
    resetInventory,
    setItens,
    setClothes
} = InventoryReducer.actions;

export const useInventory = (state: any) => state.inventory;

