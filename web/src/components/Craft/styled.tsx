import styled from 'styled-components';
import BG from "../../assets/HEADER-BG.png";

const Container = styled.div`
    width: 100%;
    height: 33.875em;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: flex-start;

    .title {
        height: 5.4375em; 
        width: 100%;
 
        & > span {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 900;
            font-size: 2.5em;
        }

        & > span:nth-child(2) {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 600;
            font-size: 1.25em;
            color: rgba(255, 255, 255, 0.5);
        }
    }

    .content {
        height: 26.5625em;
        width: 100%;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }

    .quantity {
        position: absolute;
        top: 0;
        right: 0;
        background-color: #ffffff;
        padding: 4px 8px;
        font-size: 12px;
    }

    .itens {
        height: 26.5625em;
        width: 19.6875em;
        display: grid;
        grid-template-columns: repeat(3, 5.9375em);
        grid-template-rows: repeat(3, 5.9375em);
        grid-gap: 0.868em;
        overflow: scroll;
        align-content: center;

        &::-webkit-scrollbar {
            display: none;
        }
    }

    .create {
        height: 5.9375em;
        width: 5.9375em;
    }
`;

export default Container;

const ContainerSelected = styled.div`
    width: 100%;
    height: 205px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    
    .title {
        height: 5em; 
        width: 100%;
 
        & > span {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 900;
            font-size: 2.5em;
        }

        & > span:nth-child(2) {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 600;
            font-size: 1.25em;
            color: rgba(255, 255, 255, 0.5);
        }
    }

    .itens {
        height: 5.9375em;
        width: 100%;
    }
`;

export {
    ContainerSelected
}