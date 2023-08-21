import styled from 'styled-components';
import BG from "../assets/BG.png";

const Container = styled.div`
    color: #fff;
    width: 100vw;
    height: 100vh;
    /* background-image: url(${BG}); */
    background-size: 100%;
    background-repeat: no-repeat;
    background-position: center;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    padding-left: 5.75em;
    background: linear-gradient(181.02deg, rgba(10, 8, 11, 0.76) 0.87%, rgba(18, 20, 26, 0.8) 99.23%), linear-gradient(169.92deg, rgba(131, 34, 255, 0.64) -72.09%, rgba(17, 7, 39, 0.736) 92.45%), radial-gradient(51.51% 50% at 43.89% 50%, rgba(19, 20, 44, 0.91) 0%, rgba(29, 26, 30, 0) 100%);
    position: absolute;
    .screen {

        width: 81.875em;
        height: 53.5em;

        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: flex-start;
        gap: 1.875em;
        position: relative;
    }

    .main {
        width: 81.875em;
        height: 47.625em;
        display: flex;
        flex-direction: row;
        gap: 3.4375em;
        
        &-inventory {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            width: 40.84%;
        }

        &-aside {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            width: 29.375em;
        }
    }
`;

export default Container;