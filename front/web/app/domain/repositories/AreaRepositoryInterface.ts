import type { SubscribedArea } from "~/domain/models/Area";

export interface AreasRepositoryInterface {
    fetchSubscribedAreas(token: string): Promise<SubscribedArea[]>;
    subscribeUser(areaId: string, token: string): void;
    unsubscribeUser(areaId: string, token:string ): void;
    createArea(action: string, reaction: string, token: string): void;
}