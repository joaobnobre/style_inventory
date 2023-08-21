import styled from 'styled-components';

const Container = styled.div`
    width: 26.590625em;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    overflow: hidden;

    .title {
        height: 5.4375em; 
        width: 100%;
        text-transform: uppercase;
        position: relative;
        white-space: nowrap;
        margin-bottom: 1.875em;

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
            white-space: nowrap;

            color: rgba(255, 255, 255, 0.5);
        }
    }

    .attachs {
        width: 19.3125em;
        height: 33.3125em;
        /* background: red; */
        border-radius: 3px;
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        align-items: flex-start;
        gap: 0.9375em;

        &-opt {
            width: 6.6875em;
            height: 100%;
            display: grid;
            grid-template-columns: 5.9375em;
            grid-auto-rows: 5.9375em;
            row-gap: 0.9375em;
            /* overflow-y: auto;
            overflow-x: auto; */
            /* direction: rtl; */
            justify-items: start;
            align-items: flex-start;

            &::-webkit-scrollbar {
                width:4px;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 5px;
            }

            &::-webkit-scrollbar-thumb {
                background: rgba(182, 153, 255, 0.2);
                border-radius: 5px;
            }
            
            
        }

        .skins {
            width: 10.5625em;
            height: 100%;
            align-items: center;
            gap: 0.625em;

            & > span {
                font-family: 'Akrobat';
                font-style: normal;
                font-weight: 900;
                font-size: 1.125em;
                letter-spacing: 0.1em;
                color: rgba(255, 255, 255, 0.5);
                white-space: nowrap;
            }

            &-grid {
                display: grid;
                grid-template-columns: repeat(3,2.875em);
                grid-auto-rows: 2.875em;
                grid-gap: 0.625em;
                justify-items: start;
                align-items: start;
                overflow: scroll;

                &::-webkit-scrollbar {
                    display: none;
                }
            }

            &-card {
                padding: 0.5em;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 3px;
                opacity: 0.7;
                transition: all 0.2s;

                &:hover {
                    opacity: 1;
                }

                .skin {
                    width: 100%;
                    height: 100%;
                    border-radius: 3px;
                }
            }
        }
    }
`;

const AttachCard = styled.div<{mode:number,img:string}>`
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    border: ${({mode}) => mode === 1 ? '2px dashed rgba(255, 255, 255, 0.2)' : 'none'};
    display: flex;
    justify-content: center;
    align-items: center;
    background-image: url(${({ img }) => img});
    background-repeat: no-repeat;
    background-size: 50%;
    background-position: center;
    position: relative;
    

    & > span {
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 900;
        font-size: 1em;
        color: rgba(255, 255, 255, 0.5);
        white-space: nowrap;
        position: absolute;
        bottom: 0.5em;
    }
`

const Card = styled.div<{ img?: string }>`
    position: relative;
    width: 12.1875em;
    height: 5.9375em;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    background-image: url(${({ img }) => img});
    background-repeat: no-repeat;
    background-position: left 1.25em top -.5em ;
    background-size: 50%;
    padding: 0.625em 0.9375em;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 0.9375em;


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
    Card,
    AttachCard
}