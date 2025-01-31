import type { AuthRepositoryInterface } from '~/domain/repositories/AuthRepositoryInterface'

export class AuthRepository implements AuthRepositoryInterface {
    private baseUrlAPI = useRuntimeConfig().public.baseUrlApi

    async login(user: { username: string; password: string }): Promise<string> {
        const response = await fetch(`${this.baseUrlAPI}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(user),
        })

        if (!response.ok) {
            throw new Error('Invalid credentials')
        }

        const data = await response.json()
        return data['token']
    }

    async register(user: { username: string; password: string }): Promise<string> {
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
        const response = await fetch(`${this.baseUrlAPI}/auth/me`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json',
            },
        })
        return response.ok;
    }
}
