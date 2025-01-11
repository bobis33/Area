import type { AssetsRepositoryInterface } from '~/domain/repositories/AssetsRepositoryInterface'

export class getAssetUrl {
    constructor(private assetsRepository: AssetsRepositoryInterface) {}

    execute(path: string): string {
        try {
            return this.assetsRepository.getAssetUrl(path)
        } catch (error) {
            console.error('Error getting asset URL:', error)
            throw new Error('getAssetUrlError')
        }
    }
}

export class fetchAsset {
    constructor(private assetsRepository: AssetsRepositoryInterface) {}

    async execute(path: string): Promise<Blob> {
        try {
            return await this.assetsRepository.fetchAsset(path)
        } catch (error) {
            console.error('Error fetching asset:', error)
            throw new Error('fetchAssetError')
        }
    }
}
