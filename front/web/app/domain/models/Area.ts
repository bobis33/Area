interface params {
    [key: string]: any;
  }
  
  interface Action {
    name: string;
    description: string;
    service: string;
    params: params;
  }
  
  interface Reaction {
    name: string;
    description: string;
    service: string;
    params: params;
  }

export interface SubscribedArea {
    _id: string;
    action: Action;
    action_params: {},
    reaction_params: {},
    reaction: Reaction;
}