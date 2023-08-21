import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

interface TradeState {

}

interface InitialState {
    osTime: number;
    owner: boolean;
    primaryItens: any[];
    secondaryItens: any[];
    playerName: string[];
    tradeState: number[];
}

const INITIAL_STATE:InitialState = {
    osTime: Math.floor(new Date().getTime() / 1000),
    owner:false,
    primaryItens:[
        {key:'joint',amount:1,image:'maconha',duration:1673676512,maxDurability:3600,name:'Maconha'}
    ],
    secondaryItens:[
        {key:'joint',amount:1,image:'maconha',duration:1673676512,maxDurability:3600,name:'Maconha'},
        {key:'joint',amount:1,image:'maconha',duration:1673676512,maxDurability:3600,name:'Maconha'}

    ],
    playerName: ['JOÃO WINCHESTER','#24560'],
    tradeState:[0,0]
};

const TradeReducer = createSlice({
    name: "trade",
    initialState: INITIAL_STATE,
    reducers: {
        resetTrade: (state) => {
            return INITIAL_STATE;
        },

        setPrimaryItens: (state, action) => {
            state.primaryItens = action.payload;
        },

        setSecondaryItens: (state, action) => {
            state.secondaryItens = action.payload;
        },

        setPlayerName: (state, action) => {
            state.playerName = action.payload;
        },

        setTradeState: (state, action) => {
            const {pos,value} = action.payload;
            state.tradeState[pos] = value;
        },

        removeItem: (state, action) => {
            const { key, duration } = action.payload;
            const nameItem = key + '-' + duration
            const oldList = state.primaryItens;
            if(state.tradeState[0] == 1) return;
            state.primaryItens = Object.values(oldList).filter((item: any) => item.key + '-' + item.duration == nameItem) 
        },

        setOwner:(state,action) => {
            state.owner = action.payload;
        },
    },
});

export default TradeReducer.reducer;

export const {setTradeState,resetTrade,setPrimaryItens,setSecondaryItens,setPlayerName,removeItem,setOwner } = TradeReducer.actions;

export const useTrade = (state: any) => state.trade;
