import type { AreasRepositoryInterface } from "~/domain/repositories/AreaRepositoryInterface";
import type { SubscribedArea } from "~/domain/models/Area";

export class Areas implements AreasRepositoryInterface {
    private baseUrlAPI = useRuntimeConfig().public.baseUrlApi
    
    async fetchSubscribedAreas(token: string): Promise<SubscribedArea[]> {
        try {
            const response = await fetch(`${this.baseUrlAPI}/area/get/subscribed`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                },
            })
            const result = await response.json()
            return result['subscribed_areas']
        } catch (error) {
            console.error('Error fetching subscribed areas:', error)
            throw new Error('Error fetching subscribed areas')
        }
    }

    async subscribeUser(area_id: string, token: string): Promise<void> {
        try {
            const response = await fetch(`${this.baseUrlAPI}/area/subscribe?area_id=${area_id}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                },
            })
            const result = await response.json()
        } catch (error) {
            console.error('Error subscribing user:', error)
        }
    }

    async unsubscribeUser(areaid: string, token: string): Promise <void> {
        try {
            const response = await fetch(`${this.baseUrlAPI}/area/unsubscribe?area_id=${areaid}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                }
            })
            const result = await response.json()
        } catch (error) {
            console.error('Error unsubscribing user:', error)
        }
    }

    async createArea(action: string, reaction: string, token:string, paramsAction:string, paramsReaction: string): Promise <void> {
        try {
            const url = `${this.baseUrlAPI}/area/create?action=${action}&reaction=${reaction}&action_params=${paramsAction}&reaction_params=${paramsReaction}`
            console.log('$url', url)
            console.log('$action', action)
            console.log('$reaction', reaction)
            console.log('$paramsAction', paramsAction)
            console.log('$paramsReaction', paramsReaction)
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                }
            })
            if (!response.ok) {
                throw new Error('Network response was not ok')
            }
            const result = await response.json()
            console.log(result.message)
            // Optionally, fetch the updated list of areas
            // fetchAreas()
        } catch (error) {
            console.error('Error creating area:', error)
        }
    }
}