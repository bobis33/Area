import type { UserRepositoryInterface } from '~/domain/repositories/UserRepositoryInterface'
import { useCookie } from "#app";
import { CookiesEnum } from "~/config/constants";

export class UserRepository implements UserRepositoryInterface {
    private baseUrlAPI = useRuntimeConfig().public.baseUrlApi

    async getUser(): Promise<string> {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value
        const response = await fetch(`${this.baseUrlAPI}/users/get/self`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
            },
        })

        if (!response.ok) {
            throw new Error('Error getting user data')
        }

        const data = await response.json()
        return data['user']
    }

    async updateUsername(username: string): Promise<string> {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value
        const response = await fetch(`${this.baseUrlAPI}/users/update/username?username=${username}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
            },
        })

        if (!response.ok) {
            throw new Error('Error updating username')
        }

        const data = await response.json()
        return data['detail']
    }

    async updatePassword(password: string): Promise<string> {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value
        const response = await fetch(`${this.baseUrlAPI}/users/update/password?password=${password}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
            },
        })

        if (!response.ok) {
            throw new Error('Error updating password')
        }

        const data = await response.json()
        return data['detail']
    }

    async updateEmail(email: string): Promise<string> {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value
        const response = await fetch(`${this.baseUrlAPI}/users/update/email?email=${email}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
            },
        })

        if (!response.ok) {
            throw new Error('Error updating email')
        }

        const data = await response.json()
        return data['detail']
    }
}
