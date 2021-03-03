//
//  UVRSSItemState.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#ifndef UVRSSItemState_h
#define UVRSSItemState_h

typedef NS_ENUM(NSUInteger, UVRSSItemState) {
    UVRSSItemNotStarted,
    UVRSSItemReading,
    UVRSSItemDone
};

typedef enum {
    UVRSSItemNotStartedOpt = 1,
    UVRSSItemReadingOpt    = 1 << 1,
    UVRSSItemDoneOpt       = 1 << 2
} UVRSSItemOptionState;

#endif /* UVRSSItemState_h */
