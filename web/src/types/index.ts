export * from './dnd';
export * from './slot';

export type ItemType = {
    lock: boolean;
    data:any;
    dragType: string;
    cardType:string;
    cardAccept:any[];
}

export type ItemLock = {
    lock: boolean;
}

