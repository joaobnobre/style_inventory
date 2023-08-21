// import { Inventory } from './inventory';
import { Slot, SlotWithItem } from './slot';

export type DragSource = {
    key: Pick<SlotWithItem, 'slot' | 'name'>;
    // inventory: Inventory['type'];
    image?: string;
};

export type DropTarget = {
    item: Pick<Slot, 'slot'>;
    // inventory: Inventory['type'];
};
