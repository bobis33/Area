import type { UserRepositoryInterface } from '~/domain/repositories/UserRepositoryInterface'

export class getUser {
    constructor(private userRepository: UserRepositoryInterface) {}

    async execute(): Promise<string | null> {
        try {
            return await this.userRepository.getUser()
        } catch (error) {
            console.error('Error getting user:', error)
            throw new Error('getUserError')
        }
    }
}

export class updateUsername {
    constructor(private userRepository: UserRepositoryInterface) {}

    async execute(username: string): Promise<string | null> {
        try {
            return await this.userRepository.updateUsername(username)
        } catch (error) {
            console.error('Error updating username:', error)
            throw new Error('updateUsernameError')
        }
    }
}

export class updatePassword {
    constructor(private userRepository: UserRepositoryInterface) {}

    async execute(password: string): Promise<string | null> {
        try {
            return await this.userRepository.updatePassword(password)
        } catch (error) {
            console.error('Error updating password:', error)
            throw new Error('updatePasswordError')
        }
    }
}

export class updateEmail {
    constructor(private userRepository: UserRepositoryInterface) {}

    async execute(email: string): Promise<string | null> {
        try {
            return await this.userRepository.updateEmail(email)
        } catch (error) {
            console.error('Error updating email:', error)
            throw new Error('updateEmailError')
        }
    }
}
