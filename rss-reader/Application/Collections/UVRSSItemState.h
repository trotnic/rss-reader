//
//  UVRSSItemState.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#ifndef UVRSSItemState_h
#define UVRSSItemState_h

typedef enum {
    UVRSSItemNotStarted = 1,
    UVRSSItemReading    = 1 << 1,
    UVRSSItemDone       = 1 << 2,
    UVRSSItemDeleted    = 1 << 3
} UVRSSItemState;

#endif /* UVRSSItemState_h */
