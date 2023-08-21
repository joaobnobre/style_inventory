import styled from 'styled-components';
import BG from '../../assets/CLOTHES-BG.png';

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

    .itens {
        height: 26.5625em;
        width: 100%;
        background-image: url(${BG});
        background-repeat: no-repeat;
        background-position: center;
        display: flex;
        flex-direction: row;
        justify-content: space-between;

        &-grid {
            height: 100%;
            width: 5.9375em;
            display: grid;
            grid-template-columns: 100%;
            grid-auto-rows: 5.9375em;
            grid-gap: 0.868em;
            overflow: scroll;
            &::-webkit-scrollbar {
                display: none;
            }
        }
    }
`;

export default Container;