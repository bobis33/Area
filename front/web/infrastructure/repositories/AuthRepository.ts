import type { AuthRepositoryInterface } from '~/domain/repositories/AuthRepositoryInterface'

export class AuthRepository implements AuthRepositoryInterface {
    private baseUrlAPI = useRuntimeConfig().public.baseUrlApi

    async login(user: { email: string; password: string }): Promise<string> {
        const response = await fetch(`${this.baseUrlAPI}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(user),
        })

        if (!response.ok) {
            throw new Error('invalidCredentials')
        }

        const data = await response.json()
        return data['token']
    }

    async register(user: { email: string; password: string }): Promise<string> {
        const response = await fetch(`${this.baseUrlAPI}/auth/register`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(user),
        })

        if (!response.ok) {
            throw new Error('Error during registration')
        }

        const data = await response.json()
        return data['token']
    }

    async verifyToken(token: string): Promise<boolean> {
        try {
            return await fetch(`${this.baseUrlAPI}/auth/me`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json',
                },
            }).then((response) => response.ok)
        } catch (error) {
            console.error('Token verification failed:', error)
            return false
        }
    }
}
