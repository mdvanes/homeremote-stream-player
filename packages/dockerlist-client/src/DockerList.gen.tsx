/* TypeScript file generated from DockerList.res by genType. */
/* eslint-disable import/first */


import * as React from 'react';

// @ts-ignore: Implicit any on import
import * as DockerListBS__Es6Import from './DockerList.bs';
const DockerListBS: any = DockerListBS__Es6Import;

import type {Style_t as ReactDOM_Style_t} from '@rescript/react/src/ReactDOM.gen';

// tslint:disable-next-line:interface-over-type-literal
export type Props = {
  readonly confirmButtonStyle?: ReactDOM_Style_t; 
  readonly onError: (_1:string) => void; 
  readonly url: string
};

export const DockerListMod_make: React.ComponentType<{
  readonly confirmButtonStyle?: ReactDOM_Style_t; 
  readonly onError: (_1:string) => void; 
  readonly url: string
}> = DockerListBS.DockerListMod.make;

export const DockerListMod: { make: React.ComponentType<{
  readonly confirmButtonStyle?: ReactDOM_Style_t; 
  readonly onError: (_1:string) => void; 
  readonly url: string
}> } = DockerListBS.DockerListMod
