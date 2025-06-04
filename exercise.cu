template <const int BM = 128, const int BN = 128, const int BK = 8, const int TM = 8, const int TN = 8>
__global__ void hgemm_t_8x8_slice_k_fp16x4_kernel(half* a, half* b, half* c, int M, int N , int K) { // fpx4: precision in every thread is fp16, while x4 means every thread works for 4 data
    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int tid = tx + ty * blockDim.x;
    __shared__ half s_a[BM][BK], s_b[BK][BN];
    
    // load data to smem
    int load_smem_a_m = tid / 2;
    int load_smem_a_k = (tid % 2 == 0) ? 0: 4;

    int load_smem_b_k = tid / 32;
    int load_smem_b_n = (tid % 32 == 0) ? 0: 4;

    int load_gmem_a_m = by * BM + load_smem_a_m;
    int load_gmem_b_n = bx * BN + load_smem_b_n;

    if (load_gmem_a_m >= M || load_gmem_b_n >= N) return;

    // for every thread, add up calculation density
    half r_c[TM][TN] = {__float2half(.0f)};

    for (int bk = 0; bk < (K + BK - 1) / BK; ++bk) {
        int load_gmem_a_k = bk * BK + load_smem_a_k;
        int load_gmem_a_addr = load_gmem_a_m * K + load_gmem_a_k; // fuck!
        //...
    }
}