import styled from 'styled-components';

const Container = styled.div`
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    transition: all 0.2s;
    padding: 0.3125em;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-size: 2.5em;
    background-repeat: no-repeat;
    justify-content: center;
    position: relative;

    .top {
        width: 100%;
        height: 0.875em;
        font-size: 0.75em;    
        font-family: 'Akrobat';
        font-style: normal;
        font-weight: 500;
        white-space: nowrap;
        
        & > b {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 500;
            color: #B699FF;
            margin-left: .2em;
            margin-right: .2em;
        }
    }

    .bottom {
        width: 100%;
        height: 1.25em;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        align-items: center;
        overflow: hidden;
        
        & > span {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 600;
            font-size: 0.75em;
            text-align: center;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            white-space: nowrap;
            width: 100%;
        }
    }

    &:hover {
        background-color: rgba(182, 153, 255, 0.2);
        box-shadow: inset 0px 0px 23.7253px #4D3F71;
        border-radius: 3px;
    }
`;

const StyleDuration = styled.div`
    bottom: 0;
    width: 80%;
    height: 0.1875em;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 14px;
    overflow: hidden;
    
    .fill {
        transition: all 0.2s ease-in-out;
        height: 100%;
        background: #5FFF9F;
        border-radius: 14px;
    }
`

const StyleUsage = styled.div`
    position: absolute;
    bottom: 1.6em;
    height: 50%;
    width: 0.25em;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 14px;
    overflow: hidden;
    right: .5em;
    transform: rotate(180deg);
    
    .fill {
        transition: all 0.2s ease-in-out;
        width: 100%;
        background: #5FFF9F;
        border-radius: 14px;
    } 
`
const StyledItem = Container

export {
    Container,
    StyleDuration,
    StyleUsage,
    StyledItem
}