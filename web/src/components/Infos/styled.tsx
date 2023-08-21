import styled from 'styled-components';

const Container = styled.div`
    width: 100%;
    height: 12.8125em;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    
    .title {
        height: 80px; 
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
        height: 48%;
        width: 100%;
        display: grid;
        grid-template-columns: repeat(2, 9.625em);
        grid-template-rows: repeat(2,2em);
        grid-gap: 1.9375em;
        align-content: end;
    }

    .item {
        width: 100%;
        height: 100%;
        text-transform: uppercase;
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        align-items: center;
        white-space: nowrap;

        & > span {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 1.25em;
            padding: 0.25em 0.625em;
            background: #B699FF;
            border-radius: 3px;
            color: #433957;
        }

        & > small {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 1.25em;
            padding: 0.25em 0.625em;
            color: rgba(255, 255, 255, 0.5);
        }
    }
`;

export default Container;