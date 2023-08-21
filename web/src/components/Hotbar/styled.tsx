import styled from 'styled-components';

const Container = styled.div`
    width: 100%;
    height: 12.8125em;
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
        display: grid;
        grid-template-columns: repeat(5, 5.9375em);
        grid-template-rows:5.9375em;
        grid-gap: 0.9375em;
        align-content: end;
    }


`;

const StyleItem = styled.div`
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    transition: all 0.2s ease-in-out;
    padding: 0.3125em;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-position: center 40%;
    background-size: 2.5em;
    background-repeat: no-repeat;
    justify-content: flex-end;
    position: relative;
    overflow: hidden;

    & > span {
        font-size: .85em;    
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 600;
        position: absolute;
        top:0;
        right: 0;
        padding: 0.1em .75em;
        background: #4D3F71;
        border-radius: 0px 3px;

    }

    & > small {
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 600;
        font-size: 0.75em;
        text-align: center;
        letter-spacing: 0.05em;
        text-transform: uppercase;
        white-space: nowrap;
        width: 100%;
        margin-bottom: 0.3125em;

    }
`;

export { Container, StyleItem };
// export default Container;