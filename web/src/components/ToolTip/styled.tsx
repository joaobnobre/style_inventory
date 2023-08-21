import styled from 'styled-components';

const Container = styled.div`
    width: 12em;
    background: #373340;
    border: 1px solid rgba(255, 255, 255, 0.01);
    border-radius: 3px;
    position: absolute;
    z-index: 100;
    flex-direction: column;
    /* align-items: center; */
    /* justify-content: space-between; */
    visibility: hidden;
    cursor: pointer;
    overflow: hidden;
    padding: 0.3em 0.2em;
    gap: 0.3125em;
    
    .top {
        width: 100%;
        height: 2.1875em;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        /* padding: 0.3125em; */

        &-img {
            width: 2.1875em;
            height: 2.1875em;
            border: 1px solid #B699FF;
            border-radius: 3px;
            background-size: 75%;
            background-position: center;
            background-repeat: no-repeat;

        }

        &-infos {
            width: 75%;
            height: 100%;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
            overflow: hidden;
            position: relative;
            & > span {
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 600;
                font-size: 1em;
                text-align: center;
                white-space: nowrap;

                &:nth-child(1){
                    text-transform: capitalize;
                    position: absolute;
                    left: 0;

                }
                &:nth-child(2){
                    color:transparent;
                    position: absolute;
                    right: 0;
                }
            }

            & > input {
                width: 100%;
                height: 100%;
                background: transparent;
                color: #fff;
                border: none;
                text-align: right;
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 600;
                font-size: 1em;
                
                &::placeholder {
                    color: #fff;
                }

                &:focus {
                    outline: none;
                }

                &::-webkit-outer-spin-button,
                &::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
                }
            }

        }
    }


    .bottom {
        width: 100%;
        height: 2.8125em;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        gap: 0.3125em;

        & > button {
            text-transform: uppercase;
            height: 100%;
            background: rgba(18, 18, 18, 0.5);
            border-radius: 3px;
            text-align: center;
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 600;
            font-size: .75em;
            letter-spacing: 0.075em;
            text-align: center;
            color: #fff;
            transition: all .2s;
            
            &:hover {
                background: rgba(182, 153, 255, 0.5);
            }
        }
    }
    
`;

export default Container;