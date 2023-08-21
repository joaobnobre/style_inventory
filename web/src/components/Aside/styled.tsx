import styled from 'styled-components';
import BG from "../../assets/HEADER-BG.png";

const Container = styled.div`
    width: 26.590625em;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: flex-start;

    .title {
        height: 5.4375em; 
        width: 100%;
        text-transform: uppercase;
        position: relative;

        .infos {
            position: absolute;
            bottom: 0;
            right: 0;
            height: 50%;
            width: 12.5em;
            display: flex;
            flex-direction: column;
            justify-content: space-between;

            &-value {
                height: 1.125em;
                width: 100%;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-direction: row;
                
                & > span {
                    font-family: 'Akrobat';
                    font-style: normal;
                    font-weight: 700;
                    font-size: 1.25em;
                    text-transform: uppercase;

                    & > b {
                        font-family: 'Akrobat';
                        font-style: normal;
                        font-weight: 700;
                        font-size: 1em;
                        text-transform: uppercase;
                        color: #B699FF;
                    }
                }
            }

            &-bar {
                width: 100%;
                height: 0.625em;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 2px;

                .fill {
                    transition: all .5s;
                    height: 100%;
                    background: #B699FF;
                    border-radius: 2px;
                }
            }
        }
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
        height: 40.3125em;
        width: 100%;
        display: grid;
        grid-template-columns: repeat(4, 5.9375em);
        grid-auto-rows: 5.9375em;
        grid-gap: 0.9375em;
        overflow: scroll;
        align-content: start;

        &::-webkit-scrollbar {
            display: none;
        }
    }
`;

export default Container;