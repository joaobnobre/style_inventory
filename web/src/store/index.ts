import {Action, configureStore, ThunkAction,combineReducers } from '@reduxjs/toolkit';
import { useDispatch } from 'react-redux';
import InventoryReducer from './Inventory'
import GlobalReducer from './Global'
import CraftReducer from './Craft'
import AsideReducer from '../components/Aside/Aside'
import ToolTipReducer from '../components/ToolTip/ToolTip'
import TradeReducer from '../components/Trade/reducer'
import AttachsReducer from '../components/Attachs/reducer'

const store = configureStore({
    reducer: {
        inventory: InventoryReducer,
        global: GlobalReducer,
        craft: CraftReducer,
        aside: AsideReducer,
        tooltip: ToolTipReducer,
        trade: TradeReducer,
        attachs:AttachsReducer
    }
}); 

export default store;

export const rootReset = combineReducers({
    inventory: InventoryReducer,
    global: GlobalReducer,
    craft: CraftReducer,
    aside: AsideReducer,
    tooltip: ToolTipReducer,
    trade: TradeReducer,
    attachs:AttachsReducer
})

export type AppDispatch = typeof store.dispatch;
export type RootState = ReturnType<typeof store.getState>;
export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, RootState, unknown, Action<string>>;
export const useAppDispatch = () => useDispatch<AppDispatch>();



