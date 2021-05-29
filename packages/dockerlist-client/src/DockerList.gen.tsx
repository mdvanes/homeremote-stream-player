/* TypeScript file generated from DockerList.res by genType. */
/* eslint-disable import/first */


import * as React from 'react';

// @ts-ignore: Implicit any on import
import * as DockerListBS__Es6Import from './DockerList.bs';
const DockerListBS: any = DockerListBS__Es6Import;

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class rdStyleT { protected opaque!: any }; /* simulate opaque types */

// tslint:disable-next-line:interface-over-type-literal
export type Props = {
  readonly confirmButtonStyle?: rdStyleT; 
  readonly onError: (_1:string) => void; 
  readonly url: string
};

export const DockerListMod_make: React.ComponentType<{
  readonly confirmButtonStyle?: rdStyleT; 
  readonly onError: (_1:string) => void; 
  readonly url: string
}> = DockerListBS.DockerListMod.make;

export const DockerListMod: { make: React.ComponentType<{
  readonly confirmButtonStyle?: rdStyleT; 
  readonly onError: (_1:string) => void; 
  readonly url: string
}> } = DockerListBS.DockerListMod
