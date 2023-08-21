import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

interface InitialState {
    weapon: {
        image?:string;
        name?:string;
        ammo?:number;
        maxAmmo?:number;
    };
    attachs: any[];
    skins: any[];
}

const INITIAL_STATE:InitialState = {
    weapon: {
        // image:"",
        // name:"",
        // ammo:0,
        // maxAmmo:0,
        
    },
    attachs: [],
    skins: [],
};

const AttachsReducer = createSlice({
    name: "attachs",
    initialState: INITIAL_STATE,
    reducers: {
        resetAttachs(state) {
            return INITIAL_STATE;
        },

        setWeapon(state, action) {
            state.weapon = action.payload;
        },

        setAttachs(state, action) {
            state.attachs = action.payload; 
        },

        setSkins(state, action) {
            state.skins = Object.values(action.payload);
        },
    },
});

export default AttachsReducer.reducer;

export const {setWeapon,resetAttachs,setAttachs,setSkins} = AttachsReducer.actions;

export const useAttachs = (state: any) => state.attachs;
