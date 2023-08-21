import { createGlobalStyle } from "styled-components";
import AkrobatRegulareot from '../fonts/Akrobat-Regular.eot'
import AkrobatRegularwoff from '../fonts/Akrobat-Regular.woff'
import AkrobatRegularwoff2 from '../fonts/Akrobat-Regular.woff2'
import AkrobatRegularttf from '../fonts/Akrobat-Regular.ttf'

export default createGlobalStyle`
    @font-face {
        font-family: 'Akrobat';
        src: url({AkrobatRegulareot});
        src: local('Akrobat'), local('Akrobat'),
            url(${AkrobatRegulareot}) format('embedded-opentype'),
            url(${AkrobatRegularwoff2}) format('woff2'),
            url(${AkrobatRegularwoff}) format('woff'),
            url(${AkrobatRegularttf}) format('truetype');
        font-weight: 500;
        font-style: normal;
    }
    
    * {
        box-sizing: border-box;
        user-select: none;
        -webkit-font-smoothing: antialiased;
        margin:0;
        padding:0;
        border:0;
        font-family: 'Gilroy-Light';
            
        /* &::-webkit-scrollbar {
            display: none;
        } */
    }
    body {
        color: #fff;
        width: 100vw;
        height: 100vh;
    }

    :root {
        font-size: 100%;
        
    }

    @media screen and (min-width: 2560px){
        :root {
            font-size: 150%;
        }
    }

    @media screen and (min-width: 1920px) and (max-width: 2560px) {
        :root {
            font-size: 100%;
        }
    }

    @media screen and (min-width: 1280px) and (max-width: 1600px) {
        :root {
            font-size: 70%;
        }
    }
    @media screen and (min-width: 800px) and (max-width: 1280px) {
        :root {
            font-size: 60%;
        }
    }
    @keyframes textAnimation {
        from {
            -moz-transform: translateX(100%);
            -webkit-transform: translateX(100%);
            transform: translateX(100%);
        }
        to {
            -moz-transform: translateX(-100%);
            -webkit-transform: translateX(-100%);
            transform: translateX(-100%);
        }
    }
    @keyframes textAnimationTooltip {
        from {
            -moz-transform: translateX(0%);
            -webkit-transform: translateX(0%);
            transform: translateX(0%);
        }
        to {
            -moz-transform: translateX(-100%);
            -webkit-transform: translateX(-100%);
            transform: translateX(-100%);
        }
    }

    .collum {
        display: flex;
        flex-direction: column;
    }

    .s-color {
        color: #B699FF;
    }

    .center {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .item-drag-preview {
        width: 4.69vw;
        height: 8.33vh;
        z-index: 100;
        position: fixed;
        pointer-events: none;
        top: 0;
        left: 0;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 2.5em;
        image-rendering: -webkit-optimize-contrast;
        background-color: rgba(182, 153, 255, 0.2);
        border-radius: 3px;
        padding: 0.3125em;

        display: flex;
        flex-direction: column;
        align-items: center;

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

        & > span {
            font-family: 'Akrobat';
            font-style: normal;
            font-weight: 700;
            font-size: 0.75em;
            text-align: center;
            letter-spacing: 0.1em;
            text-transform: uppercase;
        }

        .duration {
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
        }
    }
        
    }
`;
