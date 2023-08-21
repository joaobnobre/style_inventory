import styled from 'styled-components';
import BG from "../../assets/HEADER-BG.png";

const Container = styled.div`
    height: 100%;
    width: 12.1875em;
    display: flex;
    flex-direction: column;
    justify-content: space-between;

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
        height: 40.3125em;
        width: 100%;
        display: grid;
        grid-template-columns: 100%;
        grid-auto-rows: 5.9375em;
        gap: 0.9375em;
        overflow: scroll;
        align-content: start;

        &::-webkit-scrollbar {
            display: none;
        }
    }

    .card {
        position: relative;
        height: 100%;
        width: 100%;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 3px;
        /* background-image: url("https://localhost/itens/ak103.png"); */
        background-repeat: no-repeat;
        background-position: left 1.25em top -.5em ;
        background-size: 50%;
        padding: 0.625em 0.9375em;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: flex-end;

        & > span {
            text-transform: capitalize;
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 0.9375em;
        }

        & > small {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 0.9375em;
            & > b {
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 700;
                font-size: 0.9375em;
                color: rgba(255, 255, 255, 0.5);
            }
        }
    }
`;

const Card = styled.div<{img?:string}>`
    position: relative;
    height: 100%;
    width: 100%;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    background-image: url(${({img}) => img});
    background-repeat: no-repeat;
    background-position: left 1.25em top 0.625em ;
    background-size: 3.75em 3.4em;
    padding: 0.625em 0.9375em;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: flex-end;

    & > span {
        text-transform: capitalize;
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 700;
        font-size: 0.9375em;
    }

    & > small {
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 700;
        font-size: 0.9375em;
        & > b {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 0.9375em;
            color: rgba(255, 255, 255, 0.5);
        }
    }
`

export {
    Container,
    Card
}