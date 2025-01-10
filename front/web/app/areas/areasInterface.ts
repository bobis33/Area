export interface SubscribedArea {
    _id: string;
    action: string;
    reaction: string;
}

export interface AreasInterface {
    fetchSubscribedAreas(token: string): Promise<SubscribedArea[]>;
    subscribeUser(areaId: string, token: string): void;
    unsubscribeUser(areaId: string, token:string ): void;
    createArea(action: string, reaction: string, token: string): void;
}