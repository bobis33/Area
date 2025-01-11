import type { AssetsRepositoryInterface } from "~/domain/repositories/AssetsRepositoryInterface";

export class AssetsRepository implements AssetsRepositoryInterface {
    private readonly baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    getAssetUrl(path: string): string {
        return `${this.baseUrl}/assets/${path}`;
    }

    async fetchAsset(path: string): Promise<Blob> {
        const url = this.getAssetUrl(path);
        const response = await fetch(url);

        if (!response.ok) {
            throw new Error(`Failed to fetch asset: ${path}`);
        }

        return response.blob();
    }
}
