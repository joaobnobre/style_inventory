import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

interface InitialState {
    receitas: any[];
    selecionada: any;
    craftLength: number;
    blocked: boolean;
}


const INITIAL_STATE:InitialState = {
    receitas: [],
    selecionada: {
        item: { name: '', image: '', item: "", avaliable: false, time:0 },
        time: 0,
        receita: [
            { name: '', item: "", amount: 0, image: '', slot: 1, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 2, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 3, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 4, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 5, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 6, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 7, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 8, dropped: false },
            { name: '', item: "", amount: 0, image: '', slot: 9, dropped: false },
        ]
    },
    craftLength: 0,
    blocked: false,
};

const CraftReducer = createSlice({
    name: "craft",
    initialState: INITIAL_STATE,
    reducers: {
        resetCraft: (state) => {
            state.selecionada = INITIAL_STATE.selecionada;
            state.blocked = false;
            state.craftLength = 0;
        },

        setReceitas: (state, action) => {
            state.receitas = action.payload;
        },

        setSelecionada: (state, action) => {
            const {item,receita} = action.payload;

            Object.keys(receita).forEach((key) => {
                const pos = state.selecionada.receita.findIndex((i:any) => i.slot === Number(key));
                state.selecionada.receita[pos] = {...state.selecionada.receita[pos],
                    name: receita[key].name,
                    item: receita[key].item,
                    amount: receita[key].amount,
                    image: receita[key].image,
                };
                state.craftLength++;
            });

            state.selecionada.item = item;
            state.selecionada.time = item.time;   
        },

        insertItem: (state, action) => {
            const {slot} = action.payload;
            const pos = state.selecionada.receita.findIndex((i:any) => i.slot === slot);
            state.selecionada.receita[pos].dropped = true
            state.craftLength = state.craftLength - 1;

            if(state.craftLength === 0){
                state.selecionada.item.avaliable = true;
            }
        },

        craftItem: (state) => {
            state.blocked = true;
        }
    },
});

export default CraftReducer.reducer;

export const { setSelecionada, resetCraft,setReceitas,insertItem,craftItem } = CraftReducer.actions;

export const useCraft = (state: any) => state.craft;
