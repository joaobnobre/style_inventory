import styled from 'styled-components';
import BG from "../../assets/HEADER-BG.png";

const Container = styled.div`
    height: 4em;
    width: 100%;

    .header {
        height: 100%;
        /* width: 25.42%; */
        background: linear-gradient(90deg, rgba(255, 255, 255, 0.05) 0%, rgba(255, 255, 255, 0) 100%);
        border-radius: 5px;
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        align-items: center;
        /* padding: 0 1.25em; */
        padding-left: 1.375em;
        padding-right: 5em;
        gap: 0.875em;
        
        & > span {
            position: relative;
            height: 100%;
            text-align: center;
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 1.25em;
        }

        .fx {
            position: absolute;
            bottom: 0;
            height: 0.25em;
            width: 100%;
            background: #B699FF;
            box-shadow: 0px 0px 10px rgba(182, 153, 255, 0.5);
            border-radius: 11px;
        }
    }

    
`;

export default Container;