import React, { FC } from "react";

interface Props {
    width?: number;
}

const BreakpointWrapper: FC<Props> = ({ width = 600, children }) => (
    <div
        style={{
            minWidth: "375px",
            maxWidth: `${width}px`,
        }}
    >
        {children}
    </div>
);

export default BreakpointWrapper;
