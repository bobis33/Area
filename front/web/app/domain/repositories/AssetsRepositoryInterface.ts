export interface AssetsRepositoryInterface {
    getAssetUrl(path: string): string;
    fetchAsset(path: string): Promise<Blob>;
}