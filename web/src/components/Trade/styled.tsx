import styled from 'styled-components';

const Container = styled.div`
    width: 26.590625em;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    gap: 1.875em;
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
                        font-size: 20px;
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
                    height: 100%;
                    width: 50%;
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


    .trade {
        width: 100%;
        height: 16.25em;
        /* background-color: red; */
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        gap: 1.0625em;

        &-top {
            width: 100%;
            height: 2.4375em;
            display: flex;
            flex-direction: row;
            position: relative;
            align-items: center;
        }

        &-circle {
            width: 2.1875em;
            height: 2.1875em;
            background-color: #D9D9D9;
            border-radius: 35px;
            margin-right: 0.625em;
        }
        
        &-info {
            display: flex;
            flex-direction: column;
            width: 8.3125em;
            height: 2.4375em;
            white-space: nowrap;
            justify-content: center;

            & > span:nth-child(1) {
                text-transform: uppercase;
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 700;
                font-size: 0.9375em;

                & > b {
                    text-transform: uppercase;
                    font-family: 'Akrobat';
                    font-style: normal;
                    font-weight: 700;
                    color: #B699FF;
                }
            }

            & > span:nth-child(2) {
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 700;
                font-size: 13px;
                color: rgba(219, 57, 96, 0.3); 
            }
        }

        &-acept {
            width: 10.5625em;
            height: 2.4375em;
            padding: 0.625em 20px;
            border-radius: 5px;
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 0.9375em;
            text-align: center;
            white-space: nowrap;
            position: absolute;
            right: 0;
        }

        &-itens {
            width: 100%;
            height: 13.8125em;
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
    }

    .state {
        &-0 {
            transition: all .3s;
            background-color: rgba(57, 219, 69, 0.2);

            &:hover {
                background-color: rgba(57, 219, 69, .75);
            }
        }
        &-1 {
            transition: all .3s;
            background-color: rgba(219, 57, 96, 0.2);

            &:hover {
                background-color: rgba(219, 57, 96, .75);
            }
        }
    }

    /* .itens {
        height: 40.3125em;
        width: 100%;
        display: grid;
        grid-template-columns: repeat(4, 5.9375em);
        grid-auto-rows: 5.9375em;
        grid-gap: 0.9375em;
        overflow: scroll;
        align-content: start;
    } */
`;

export default Container;