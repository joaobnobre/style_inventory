import React from 'react';
import ReactDOM from 'react-dom/client';
import GlobalStyled from './style/GlobalStyle';
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import { Provider } from 'react-redux';
import store from './store';
import App from './components/App';

ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
        <GlobalStyled />
        <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true, enableTouchEvents: true }}>
            <Provider store={store}>
                <App />
            </Provider>
        </DndProvider>
    </React.StrictMode>

);
