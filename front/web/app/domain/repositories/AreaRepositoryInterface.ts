import type { SubscribedArea, Area } from "~/domain/models/Area";

export interface AreasRepositoryInterface {
    fetchSubscribedAreas(token: string): Promise<Area[]>;
    subscribeUser(areaId: string, token: string): void;
    unsubscribeUser(areaId: string, token:string ): void;
    createArea(action: string, reaction: string, token: string, paramsAction:string, paramsReaction:string): void;
}